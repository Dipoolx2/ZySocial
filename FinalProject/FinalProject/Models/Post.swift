import Foundation

struct Post: Codable, Identifiable, Hashable, Equatable {
    let id: Int64
    let userId: Int64
    let image: String?
    let caption: String
    let showLikes: Bool
    let allowComments: Bool
    var likeCount: Int
    let postDate: Date
    
    init(id: Int64, userId: Int64, image: String?, caption: String, showLikes: Bool, allowComments: Bool, likeCount: Int, postDate: Date) {
        self.id = id
        self.userId = userId
        self.image = image
        self.caption = caption
        self.showLikes = showLikes
        self.allowComments = allowComments
        self.likeCount = likeCount
        self.postDate = postDate
    }
    
    // Encode the PostDate property as a string using the same date format used in the decoding implementation.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(image, forKey: .image)
        try container.encode(caption, forKey: .caption)
        try container.encode(showLikes, forKey: .showLikes)
        try container.encode(allowComments, forKey: .allowComments)
        try container.encode(likeCount, forKey: .likeCount)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let dateString = formatter.string(from: postDate)
        try container.encode(dateString, forKey: .postDate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "postId", userId = "userId", image = "image", caption = "caption", showLikes = "showLikes", allowComments = "allowComments", likeCount = "likeCount", postDate = "postDate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        userId = try container.decode(Int64.self, forKey: .userId)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        caption = try container.decode(String.self, forKey: .caption)
        showLikes = try container.decode(Bool.self, forKey: .showLikes)
        allowComments = try container.decode(Bool.self, forKey: .allowComments)
        likeCount = try container.decode(Int.self, forKey: .likeCount)
        
        let dateString = try container.decode(String.self, forKey: .postDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        if let date = formatter.date(from: dateString) {
            postDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .postDate, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }

}
