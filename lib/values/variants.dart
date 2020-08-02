class Variant {
  final String appName;
  final String variantLabel;
  final String apiApplicationId;
  final String baseUrl;
  final String orgToken;
  final String clusterId;

  Variant.production()
      : appName = "JacobSpears",
        variantLabel = "",
        apiApplicationId = "com.nku.jacobspears",
        baseUrl = "https://api.prod.gogo.guru",
        orgToken = "",
        clusterId = "";


  Variant.test()
      : appName = "JacobSpears Test",
        variantLabel = "test",
        apiApplicationId = "com.nku.jacobspears.test",
        baseUrl = "https://api.qa.gogo.guru",
        orgToken = "",
        clusterId = "";

  Variant.development()
      : appName = "JacobSpears Dev",
        variantLabel = "dev",
        apiApplicationId = "com.nku.jacobspears.dev",
        baseUrl = "https://api.dev.gogo.guru",
        orgToken = "d6nRJ4TQJPxO6bKpFiSV9V3eagk82L22j3kX20jiQ_z_XZybMVNHd-3KQ2nKAqrkfGSG63Wkowmn-yUaoyCz2kQFozONEAXRbFyNGzV8jCKDAsX02O2dMNQzJhWgvfweXNJjkU_uhcGkCHqY35iTiFfdPEWJVm1tApJIdmWTrDZRi6YAg98m3GUXihmHHLH0XJ_LW35Zk3adG25loIzryYEW-UGS1rDouqhTO8D9G5wYqqFQ2oP7n9ddnRlhrKm8Kwjk_FkFoyTdq-WYJmZvmlzDeGtt7RKGrCjwPm3cGVxtKn1h3nq_70W3lTjNet_CmYMFFYDcSxZEvw",
        clusterId = "a5ed0781-96cc-454c-b641-06f8261d3e64";
}