use serde::{Deserialize, Serialize};

/// The Status object used to inform about the health of the app
#[derive(Serialize, Deserialize, Debug)]
pub struct Status {
  /// the `status` String - being for now always `Ok` if one can reach endpoint
  pub status: String,
}
