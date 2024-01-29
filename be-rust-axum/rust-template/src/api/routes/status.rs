use axum::{routing::get, Json, Router};
use http::StatusCode;
use tracing::debug;

use crate::models::status::Status;

/// Status Router - contains one single GET health endpoint, mostly used for OpenShift probes
pub fn create_route() -> Router {
  Router::new().route("/status", get(get_status))
}

/// This is a private route that won't be documented.
///
/// Unless you run: `cargo doc --document-private-items --open`
async fn get_status() -> (StatusCode, Json<Status>) {
  debug!("Returning status info");
  (
    StatusCode::OK,
    Json(Status {
      status: "Ok".to_owned(),
    }),
  )
}
