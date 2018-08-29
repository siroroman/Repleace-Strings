
class TestString {

    func hasString() {
        /// value is "Meeting name" and it is not in new strings
        /// output should be "NEW-KEY FOR TEXT: Meeting name"
        /// NSxLocalizedString("MeetingPointTableViewController.Meeting.Name", comment: "")
        L10n.meetingPointPlaceholder

        /// value is "Password" and is contained in new strings for key "basic.password"
        /// output should be L10n.basicPassword"
        /// shoul be included in translation list
        /// NSxLocalizedString("PasswordRegisterViewController.TermsAndConditions.Placeholder", comment: "")
        PasswordRegisterViewController.TermsAndConditions.Placeholder
        L10n.basicCancel
        VisitorAccountViewController.Welcome.Title
    }

}
