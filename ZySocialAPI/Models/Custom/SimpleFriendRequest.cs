namespace ZySocialAPI.Models.Custom
{
    public class SimpleFriendRequest
    {
        public Int64 UserSenderId { get; set; }
        public Int64 UserReceiverId { get; set; }
        public bool Accepted { get; set; }
        public bool Responded { get; set; }
        public Int64 FriendRequestId { get; set; }
        public DateTime SendDate { get; set; } = DateTime.Now;
    }
}
