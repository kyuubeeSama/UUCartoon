source 'https://gitee.com/mirrors/CocoaPods-Specs.git'
platform :ios,'13.0'
use_frameworks!
target 'UUCartoon' do
#  网络请求
 pod 'Alamofire'
#  图片缓存
  pod 'Kingfisher'
#  控件适配
#pod 'SnapKit'
#  加载样式
pod 'Toast-Swift'
#  键盘弹出
pod 'IQKeyboardManagerSwift'
#  空页面判断
pod 'EmptyDataSet-Swift'
#  json解析
pod 'SwiftyJSON'
pod 'HandyJSON'
#  应用内自定义通知
pod 'NotificationBannerSwift'
# 侧滑菜单
pod 'SideMenu'
# 暗黑模式
pod 'FluentDarkModeKit'
# 数据库
pod 'GRDB.swift'
#XPATH
pod 'Ji'
# 导航栏
pod 'JXSegmentedView'

pod 'ReactiveCocoa'

#上拉下拉
pod 'ESPullToRefresh'

pod 'ProgressHUD'

end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
    end
end
