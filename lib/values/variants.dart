class Variant {
  final String appName;
  final String variantLabel;
  final String apiApplicationId;
  final String baseUrl;

  Variant.production()
      : appName = "JacobSpears",
        variantLabel = "",
        apiApplicationId = "com.nku.jacobspears",
        baseUrl = "https://api.prod.gogo.guru";


  Variant.test()
      : appName = "JacobSpears Test",
        variantLabel = "test",
        apiApplicationId = "com.nku.jacobspears.test",
        baseUrl = "https://api.qa.gogo.guru";

  Variant.development()
      : appName = "JacobSpears Dev",
        variantLabel = "dev",
        apiApplicationId = "com.nku.jacobspears.dev",
        baseUrl = "https://api.dev.gogo.guru";
}