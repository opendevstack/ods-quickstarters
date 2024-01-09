use axum::{Json, Router};
use http::StatusCode;
use std::net::SocketAddr;
use tokio::signal::unix::{signal, SignalKind};
use tracing::info;

use crate::api::routes;
use crate::models::status::Status;

/// The app function that configures and creates the Axum router for our API
pub fn app() -> Router {
  Router::new()
    .nest(
      "/v1",
      // All public v1 routes will be merged here.
      Router::new().merge(routes::status::create_route()),
    )
    .fallback(fallback)
}

/// The serve function that starts the Axum server
pub async fn serve(address: SocketAddr) {
  let listener = tokio::net::TcpListener::bind(address).await.unwrap();

  info!("Server listening on {}", &address);
  axum::serve(listener, app().into_make_service())
    .with_graceful_shutdown(shutdown_signal())
    .await
    .expect("Failed to start server");
}

/// The fallback function when a non configured endpoint is reached
async fn fallback() -> (StatusCode, Json<Status>) {
  (
    StatusCode::NOT_FOUND,
    Json(Status {
      status: "Not found".to_owned(),
    }),
  )
}

/// Setup example of the OS signal handlers to catch for proper server graceful shutdown.
async fn shutdown_signal() {
  let interrupt = async {
    signal(SignalKind::interrupt())
      .expect("failed to install signal handler")
      .recv()
      .await;
  };
  let terminate = async {
    signal(SignalKind::terminate())
      .expect("failed to install signal handler")
      .recv()
      .await;
  };
  tokio::select! {
      _ = interrupt => {},
      _ = terminate => {},
  }
}
