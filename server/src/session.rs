//! Implementation of the WebSocket session manager.

use actix::{Actor, Addr, AsyncContext, Handler, Message, StreamHandler};
use actix_web_actors::ws;
use bytestring::ByteString;

use crate::SessionsStore;

/// Sender of the broadcast messages to the all WebSocket clients except current
/// [`WsSession`].
#[derive(Debug)]
struct Broadcaster {
    /// Store of the all [`WsSession`]s related to the one user.
    sessions: SessionsStore,

    /// ID of the [`WsSession`] for which this [`Broadcaster`] is created.
    ///
    /// Used for owner [`WsSession`] filtering when sending broadcast messages.
    id: u32,
}

impl Broadcaster {
    /// Returns new [`Broadcaster`] for the provided [`WsSession`].
    ///
    /// Registers provided [`WsSession`] in the provided [`SessionsStore`].
    pub fn new(sessions: SessionsStore, addr: Addr<WsSession>) -> Self {
        let id = sessions.register_session(addr);
        Self { sessions, id }
    }

    /// Sends provided [`ByteString`] to the all [`WsSession`] except current
    /// [`WsSession`].
    pub fn text(&self, text: &ByteString) {
        for session in self.sessions.get_sessions_except_id(self.id) {
            session.do_send(SendText(text.clone()));
        }
    }
}

impl Drop for Broadcaster {
    fn drop(&mut self) {
        self.sessions.unregister(self.id);
    }
}

/// Notifies [`WsSession`] about necessity to send provided [`ByteString`].
#[derive(Debug, Clone, Message)]
#[rtype(result = "()")]
struct SendText(pub ByteString);

impl Handler<SendText> for WsSession {
    type Result = ();

    fn handle(
        &mut self,
        msg: SendText,
        ctx: &mut Self::Context,
    ) -> Self::Result {
        ctx.text(msg.0);
    }
}

/// Manager of the WebSocket connection with a remote client.
#[allow(clippy::module_name_repetitions)]
#[derive(Debug)]
pub struct WsSession {
    /// [`SessionsStore`] related to this [`WsSession`].
    store: SessionsStore,

    /// Sender of the broadcast messages to the all WebSocket clients except
    /// this [`WsSession`].
    ///
    /// Will be initialized at [`Actor::started`].
    ///
    /// Should be `Some` all time after [`Actor::started`].
    broadcaster: Option<Broadcaster>,
}

impl WsSession {
    /// Returns new [`WsSession`].
    pub fn new(store: SessionsStore) -> Self {
        Self {
            store,
            broadcaster: None,
        }
    }
}

impl Actor for WsSession {
    type Context = ws::WebsocketContext<Self>;

    /// Initializes [`Broadcaster`] of this [`WsSession`].
    fn started(&mut self, ctx: &mut Self::Context) {
        self.broadcaster =
            Some(Broadcaster::new(self.store.clone(), ctx.address()));
    }
}

impl StreamHandler<Result<ws::Message, ws::ProtocolError>> for WsSession {
    /// On [`ws::Message::Text`] broadcasts received text to the all related
    /// [`WsSession`]s except this one.
    fn handle(
        &mut self,
        msg: Result<ws::Message, ws::ProtocolError>,
        ctx: &mut Self::Context,
    ) {
        match msg {
            Ok(msg) => match msg {
                ws::Message::Text(text) => {
                    self.broadcaster.as_ref().unwrap().text(&text);
                }
                ws::Message::Ping(ping) => ctx.pong(&*ping),
                _ => {
                    println!("Received message of unknown type");
                }
            },
            Err(err) => {
                println!("StreamHandler error: {:?}", err);
            }
        }
    }
}
