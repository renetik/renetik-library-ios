public extension String {
    func addSizeToHtmlImageTags(_ width: CGFloat) -> String {
        let endTag = "/>"
        let tags = findTags(startTag: "<img ", endTag: endTag, where: { !$0.contains("width=") })
        let string = NSMutableString(string: self)
        for tag in tags.reversed() {
            string.insert(" width='\(Int(width))' height='\(Int(width / 2))' ", at: tag.endTagIndex)
            string.insert("<br/>", at: tag.startTagIndex)
        }
        return string as String
    }
}
