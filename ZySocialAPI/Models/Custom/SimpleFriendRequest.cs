namespace ZySocialAPI.Models.Custom
{
    public class SimpleFriendRequest
    {
        public SimpleFriendRequest(FriendRequest request)
        {
            this.UserSenderId= request.UserSenderId;
            this.SendDate = request.SendDate;
            this.UserReceiverId= request.UserReceiverId;
            this.Accepted = request.Accepted;
            this.Responded= request.Responded;
            this.FriendRequestId = request.FriendRequestId;
        }
        

        public Int64 UserSenderId { get; set; }
        public Int64 UserReceiverId { get; set; }
        public bool Accepted { get; set; }
        public bool Responded { get; set; }
        public Int64 FriendRequestId { get; set; }
        public DateTime SendDate { get; set; } = DateTime.Now;
    }
}
