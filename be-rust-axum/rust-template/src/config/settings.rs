use dotenvy::dotenv;
use lazy_static::lazy_static;
use serde::Deserialize;

lazy_static! {
  /// The lazy loaded static Settings struct that calls `Settings::load()` when the app starts,
  /// and that is used whenever a configuration attribute is required within the app.
  pub static ref SETTINGS: Settings = Settings::new().unwrap();
}

/// The Settings struct where the required config for our app is loaded into
#[derive(Deserialize, Debug)]
pub struct Settings {
  /// The server port to listen to.
  #[serde(default = "default_app_port")]
  pub port: u16,
  /// We make use of tracing with rust logging integration (RUST_LOG).
  #[serde(default = "default_logging")]
  pub default_logging: String,
}

fn default_app_port() -> u16 {
  8080
}
fn default_logging() -> String {
  "{{crate_name}}=debug,tower_http=trace,axum::rejection=trace".to_owned()
}

impl Settings {
  pub fn new() -> Result<Self, envy::Error> {
    dotenv().ok();

    let settings = match envy::from_env::<Settings>() {
      Ok(config) => config,
      Err(error) => return Err(error),
    };
    Ok(settings)
  }
}
