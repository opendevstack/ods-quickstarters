use {{crate_name}}::api::router::serve;
use {{crate_name}}::config::settings::SETTINGS;

use std::net::SocketAddr;
use tracing_subscriber::FmtSubscriber;

#[tokio::main]
async fn main() {
  // https://docs.rs/tracing/latest/tracing/subscriber/fn.set_global_default.html
  tracing::subscriber::set_global_default(
    FmtSubscriber::builder()
      // all spans/events with a level higher than TRACE (e.g, debug, info, warn, etc.)
      // will be written to stdout.
      .with_max_level(SETTINGS.log_level())
      // completes the builder.
      .finish(),
  )
  .expect("setting global default subscriber failed");

  let address = SocketAddr::from(([0, 0, 0, 0], SETTINGS.port));

  serve(address).await;
}
