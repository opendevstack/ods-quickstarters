use axum::http::{Request, StatusCode};
use tower::ServiceExt; // for `call`, `oneshot`, and `ready`

use {{crate_name}}::{api::router::app, models::status::Status};

mod common;
use common::{response_json, RequestBuilderExt};

#[tokio::test]
async fn get_status_route_ok() {
  let app = app();

  let mut res = app
    .oneshot(Request::get("/v1/status").empty_body())
    .await
    .unwrap();
  let status_code = res.status();
  let body: Status = response_json(&mut res).await;

  // Status code:
  let actual = status_code;
  let expected = StatusCode::OK;
  assert_eq!(actual, expected);

  // Body:
  let actual = body.status;
  let expected = "Ok";
  assert_eq!(actual, expected);
}
