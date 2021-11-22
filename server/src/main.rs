//! Implementation of the WebSocket server which broadcasts messages from the
//! one client to the many other connected clients.

mod session;
mod sessions_store;

use actix_web::{
    web::{resource, Data, Payload},
    App, HttpRequest, HttpResponse, HttpServer,
};
use actix_web_actors::{ws, ws::WebsocketContext};

use crate::sessions_store::SessionsStore;

use self::session::WsSession;

/// WebSocket index handler.
///
/// Starts new [`WsSession`] for the connected client.
async fn ws_index(
    request: HttpRequest,
    state: Data<SessionsStore>,
    payload: Payload,
) -> actix_web::Result<HttpResponse> {
    let ws = WsSession::new(state.get_ref().clone());
    Ok(
        ws::handshake(&request)?.streaming(WebsocketContext::with_codec(
            ws,
            payload,
            actix_http::ws::Codec::new(),
        )),
    )
}

/// Runs WebSocket [`HttpServer`].
async fn run() {
    let port = std::env::var("PORT").unwrap_or_else(|_| "8080".to_string());
    println!("{}", port);
    let ctx = SessionsStore::new();
    HttpServer::new(move || {
        App::new()
            .app_data(Data::new(ctx.clone()))
            .configure(|cfg| {
                cfg.service(
                    resource("/").route(actix_web::web::get().to(ws_index)),
                );
            })
    })
    .bind(format!("0.0.0.0:{}", port))
    .unwrap()
    .run()
    .await
    .unwrap();
}

#[actix::main]
async fn main() {
    run().await;
}
