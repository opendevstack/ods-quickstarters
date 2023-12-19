use axum::{Json, Router};
use http::StatusCode;
use std::net::SocketAddr;
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

/// The fallback function when a non configured endpoint is reached
async fn fallback() -> (StatusCode, Json<Status>) {
  (
    StatusCode::NOT_FOUND,
    Json(Status {
      status: "Not found".to_owned(),
    }),
  )
}

/// The serve function that starts the Axum server
pub async fn serve(address: SocketAddr) {
  let listener = tokio::net::TcpListener::bind(address).await.unwrap();

  info!("Server listening on {}", &address);
  axum::serve(listener, app().into_make_service())
    .await
    .expect("Failed to start server");
}
