/// shorthand notation for single data constructor custom types
/// the full version would have the explicit Data Constructor like
/// type Datum { Datum {...fields are the same...} }
pub type Datum {
  title: ByteArray,
  description: ByteArray,
  goal: Int,
  /// creator: Address,
  creator: ByteArray,
  campaign_id: Int,
  deadline: Int,
  current_fund: Int,
}

/// multiple data constructors
pub type Action {
  Create
  Update
  Support
  Claim
}

pub type Redeemer {
  action: Action,
  amount: Int,
  campaign_id: Int,
  /// donor: Address,
  donor: ByteArray,
}
