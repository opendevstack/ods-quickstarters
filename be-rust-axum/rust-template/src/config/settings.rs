use lazy_static::lazy_static;
use serde::Deserialize;
use tracing::Level;

lazy_static! {
  /// The lazy loaded static Settings struct that calls `Settings::load()` when the app starts,
  /// and that is used whenever a configuration attribute is required within the app.
	pub static ref SETTINGS: Settings = Settings::load();
}

/// The Settings struct where the required config for our app is loaded into
#[derive(Deserialize, Debug)]
pub struct Settings {
	/// The server port to listen to - must be u16 (number).
	///
	/// Defaults to 8080
  pub port: u16,
	/// The server global log_level - must be either "TRACE", "DEBUG", "INFO", "WARN" or "ERROR".
	///
	/// Defaults to DEBUG
  pub log_level: String,
}

impl Settings {
	/// Creates/loads the `Settings` with the configuration parameters required for the app
  pub fn load() -> Self {
    Settings {
      port: std::env::var("PORT")
        .unwrap_or("8080".to_owned())
        .parse::<u16>()
        .unwrap(),
      log_level: std::env::var("LOG_LEVEL").unwrap_or("DEBUG".to_owned()),
    }
  }

	/// Translates the `log_level` String to the proper `tracing::Level` value.
  pub fn log_level(&self) -> Level {
    match self.log_level.as_str() {
      "ERROR" => Level::ERROR,
      "WARN" => Level::WARN,
      "INFO" => Level::INFO,
      "DEBUG" => Level::DEBUG,
      "TRACE" => Level::TRACE,
      _ => Level::DEBUG,
    }
  }
}
