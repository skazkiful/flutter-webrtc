//! Implementation of the store of all [`WsSession`]s registered on this server.

use std::{
    collections::HashMap,
    sync::{Arc, Mutex},
};

use actix::Addr;

use crate::session::WsSession;

/// Inner structure of the [`SessionStore`].
#[derive(Debug)]
struct Inner {
    /// All [`WsSession`]s registered in this [`SessionsStore`].
    store: HashMap<u32, Addr<WsSession>>,

    /// Next ID of the next [`WsSession`] which will be registered in this
    /// [`SessionsStore`].
    next_id: u32,
}

/// Store of all [`WsSession`]s registered on this server.
#[derive(Clone, Debug)]
pub struct SessionsStore(Arc<Mutex<Inner>>);

impl SessionsStore {
    /// Returns new empty [`SessionsStore`].
    pub fn new() -> Self {
        Self(Arc::new(Mutex::new(Inner {
            store: HashMap::new(),
            next_id: 0,
        })))
    }

    /// Registers provided [`WsSession`] in this [`SessionsStore`].
    ///
    /// Returns ID generated for the provided [`WsSession`].
    pub fn register_session(&self, session: Addr<WsSession>) -> u32 {
        let mut inner = self.0.lock().unwrap();
        let id = inner.next_id;
        inner.next_id += 1;
        inner.store.insert(id, session);

        id
    }

    /// Returns all [`WsSession`]s except one with a provided ID.
    pub fn get_sessions_except_id(
        &self,
        excluded_id: u32,
    ) -> Vec<Addr<WsSession>> {
        self.0
            .lock()
            .unwrap()
            .store
            .iter()
            .filter_map(|(id, session)| {
                if *id == excluded_id {
                    None
                } else {
                    Some(session.clone())
                }
            })
            .collect()
    }

    /// Unregisters [`WsSession`] with a provided ID from this
    /// [`SessionsStore`].
    pub fn unregister(&self, id: u32) {
        self.0.lock().unwrap().store.remove(&id);
    }
}
