namespace ZySocialAPI.Models.Custom
{
    public class SimpleNotification
    {
        public Int64 NotificationId { get; set; }
        public Int64 UserId { get; set; }
        public String Title { get; set; } = null!;
        public String? Body { get; set; }
    }
}
