default_platform(:ios)

platform :ios do
  desc "Build and archive the app"
  lane :build do
    gym(
      workspace: "WebView.xcodeproj",
      scheme: "WebView",
      export_options: {
        method: "enterprise",
        provisioningProfiles: {
          "com.fss.disha.WebView" => "FINANCIAL SOFTWARE AND SYSTEMS PRIVATE LIMITED"
        }
      }
    )
  end
end
