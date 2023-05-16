using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZySocialAPI.Models
{
    public partial class FriendRequest
    {
        public Int64 UserSenderId { get; set; }
        public Int64 UserReceiverId { get; set; }
        public bool Accepted { get; set; }
        public bool Responded { get; set; }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Int64 FriendRequestId { get; set; }
        public DateTime SendDate { get; set; }

        public virtual User UserReceiver { get; set; } = null!;
        public virtual User UserSender { get; set; } = null!;
    }
}
