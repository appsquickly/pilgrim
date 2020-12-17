import UIKit
import Pilgrim

class StoryViewController : UIViewController {

    /**
     The built instance is auto-injected from the QuestAssembly 
    */
    @Assembled var knight: Knight;

    private(set) var story: Story

    init(story: Story) {
        self.story = story
    }
}








protocol Story {

}