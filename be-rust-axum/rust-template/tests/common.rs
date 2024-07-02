use axum::body::Body;
use axum::extract::Request;
use axum::http::header::CONTENT_TYPE;
use axum::http::request;
use axum::response::Response;
use http_body_util::BodyExt; // for `collect`

pub trait RequestBuilderExt {
  // fn json(self, json: serde_json::Value) -> Request<Body>;
  fn empty_body(self) -> Request<Body>;
}

impl RequestBuilderExt for request::Builder {
  // fn json(self, json: serde_json::Value) -> Request<Body> {
  //   self
  //     .header("Content-Type", "application/json")
  //     .body(Body::from(json.to_string()))
  //     .expect("Failed to build request")
  // }
  fn empty_body(self) -> Request<Body> {
    self.body(Body::empty()).expect("Failed to build request")
  }
}

// Generics enables us to use this method with any Type that implements Deseserialize
pub async fn response_json<T: for<'a> serde::Deserialize<'a>>(res: &mut Response<Body>) -> T {
  assert_eq!(
    res
      .headers()
      .get(CONTENT_TYPE)
      .expect("expected Content-Type"),
    "application/json"
  );

  let body = res.body_mut().collect().await.unwrap().to_bytes();

  serde_json::from_slice(&body).expect("Failed to read response body as JSON")
}
