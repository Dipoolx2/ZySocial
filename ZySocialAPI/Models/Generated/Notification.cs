using System;
using System.Collections.Generic;

namespace ZySocialAPI.Models
{
    public partial class Notification
    {
        public long NotificationId { get; set; }
        public long UserId { get; set; }
        public string Title { get; set; } = null!;
        public string? Body { get; set; }

        public virtual User User { get; set; } = null!;
    }
}
