import Foundation

struct FriendRequest: Codable {
    var userSenderId: Int64
    var userReceiverId: Int64
    var accepted: Bool
    var responded: Bool
    var friendRequestId: Int64
    var sendDate: String
    
    enum CodingKeys: String, CodingKey {
        case userSenderId
        case userReceiverId
        case accepted
        case responded
        case friendRequestId
        case sendDate
    }
    
    init(userSenderId: Int64, userReceiverId: Int64, accepted: Bool, responded: Bool, friendRequestId: Int64, sendDate: String) {
        self.userSenderId = userSenderId
        self.userReceiverId = userReceiverId
        self.accepted = accepted
        self.responded = responded
        self.friendRequestId = friendRequestId
        self.sendDate = sendDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userSenderId = try container.decode(Int64.self, forKey: .userSenderId)
        userReceiverId = try container.decode(Int64.self, forKey: .userReceiverId)
        accepted = try container.decode(Bool.self, forKey: .accepted)
        responded = try container.decode(Bool.self, forKey: .responded)
        friendRequestId = try container.decode(Int64.self, forKey: .friendRequestId)
        sendDate = try container.decode(String.self, forKey: .sendDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userSenderId, forKey: .userSenderId)
        try container.encode(userReceiverId, forKey: .userReceiverId)
        try container.encode(accepted, forKey: .accepted)
        try container.encode(responded, forKey: .responded)
        try container.encode(friendRequestId, forKey: .friendRequestId)
        try container.encode(sendDate, forKey: .sendDate)
    }
}
