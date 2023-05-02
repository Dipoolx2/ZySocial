using System;
using System.Collections.Generic;

namespace ZySocialAPI.Models
{
    public partial class FriendRequest
    {
        public long UserSenderId { get; set; }
        public long UserReceiverId { get; set; }
        public bool Accepted { get; set; }
        public bool Responded { get; set; }
        public long FriendRequestId { get; set; }
        public DateTime SendDate { get; set; }

        public virtual User UserReceiver { get; set; } = null!;
        public virtual User UserSender { get; set; } = null!;
    }
}
