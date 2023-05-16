namespace ZySocialAPI.Models.Custom
{
    public class SimpleComment
    {
        public Int64 CommentId { get; set; }
        public Int64 PostId { get; set; }
        public String Body { get; set; } = null!;
        public Int64 UserId { get; set; }
    }
}
