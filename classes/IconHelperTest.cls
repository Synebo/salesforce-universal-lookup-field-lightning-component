@isTest
public class IconHelperTest {

    @isTest
    public static void test() {
        
        IconHelper helper = new IconHelper();
        IconHelper.getLightningIcon('');
        
        String icon = IconHelper.getLightningIcon('plane32.png');
        
        System.assertEquals('custom20', icon);
    }
    
}