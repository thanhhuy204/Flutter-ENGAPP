'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "b1540001b49c6c14000263e32f7cfaec",
"assets/AssetManifest.bin.json": "8f97b063b0f33a28a025b494162efe6a",
"assets/AssetManifest.json": "3416453f20db14f8f0099dfc6d011668",
"assets/assets/audio/endgame.mp3": "22b6170bc29f8c0909dbd9965fcb5d46",
"assets/assets/audio/lose.mp3": "8545000ca348368ba198d333bb7b94a9",
"assets/assets/audio/onepiece.mp3": "964d31db35e3a504f3155dd2a3595f54",
"assets/assets/audio/space_music.mp3": "8b0b47e2315f46f4fe52f2b24ec31517",
"assets/assets/audio/win.mp3": "942ca29a0a8b48a9f7a21ada4b0eaee1",
"assets/assets/fonts/Fredoka/Fredoka-Bold.ttf": "72b686e43142104ae5e80b227e15fb8e",
"assets/assets/fonts/Fredoka/Fredoka-Regular.ttf": "614a384e20be581cd2a8e0941028c270",
"assets/assets/fonts/Nunito/Nunito-Bold.ttf": "ba43cdecf9625c0dcec567ba29555e15",
"assets/assets/fonts/Nunito/Nunito-Regular.ttf": "b83ce9c59c73ade26bb7871143fd76bb",
"assets/assets/fonts/PrincessSofia/PrincessSofia-Regular.ttf": "f7e33739ac1a7de9b5e3746e37bb4323",
"assets/assets/fonts/Sunnyspells/Sunnyspells-Regular.otf": "fe02cfe08e0ae6c436a469393ec9fa0d",
"assets/assets/images/animals/buffalo.png": "35df61131b3fa7f2831db0afb55af245",
"assets/assets/images/animals/camel.png": "a368a9242e2d9e91957c274758e62143",
"assets/assets/images/animals/cat.png": "c9b1bba98a884a0c8e4f83829aec933f",
"assets/assets/images/animals/cheetah.png": "3e9f1267e7eb7d10fc428877b21cca5e",
"assets/assets/images/animals/chicken.png": "e326c1783d2530ab78787ce7fad61e6b",
"assets/assets/images/animals/chimpanzee.png": "5c9ee2979059df9ff3354f1c17314edb",
"assets/assets/images/animals/crab.png": "45e70d0091bc07447d0ecb3aa2923f39",
"assets/assets/images/animals/crocodile.png": "92798fe2f01cb9f13d140311dce0e33f",
"assets/assets/images/animals/deer.png": "38b86ea4bf29e47c97ac5c6bc9d69071",
"assets/assets/images/animals/dog.png": "4a19626fe5da9d8a5cebf2882362dc5a",
"assets/assets/images/animals/dolphin.png": "648c762ffe953550f28955727b39c303",
"assets/assets/images/animals/duck.png": "9d5d1910734a80bafe5c66f6a98e3df7",
"assets/assets/images/animals/eagle.png": "aca83a6db4845e4479d9d31018a1bc03",
"assets/assets/images/animals/elephant.png": "757d9470f1804e686ba665204275cd67",
"assets/assets/images/animals/fish.png": "7a600b86bf5ab23be6fab1bed109e184",
"assets/assets/images/animals/fox.png": "80e274fd1bfb4ae275246ae2b6312a12",
"assets/assets/images/animals/giraffe.png": "815d7e519e979ef6b358cd59f2cfa7fd",
"assets/assets/images/animals/goat.png": "6f2c1a9ca39f539b953172df57eb7906",
"assets/assets/images/animals/gorilla.png": "7e5bd1bbf38d6619e48f9f157632b285",
"assets/assets/images/animals/hippopotamus.png": "be45fc0f5bd004a1a2ca2128347422f4",
"assets/assets/images/animals/horse.png": "b190f4d7f25f7eed00fcd21208dff996",
"assets/assets/images/animals/kangaroo.png": "f5fdfc0d3a0ef9077d7f1bc7bdf55d72",
"assets/assets/images/animals/leopard.png": "0525e1c14b999f8d9f0eca8cbaff9396",
"assets/assets/images/animals/lion.png": "798fd10b5a5c19ec9022408c99268f43",
"assets/assets/images/animals/monkey.png": "3f3343bfa3c19e169c881bbad2399972",
"assets/assets/images/animals/mouse.png": "64a063b9db4cd224710f6a929e5d645b",
"assets/assets/images/animals/mule.png": "5c50521833949df74102e38c240b2cfa",
"assets/assets/images/animals/octopus.png": "5395da23944b937ff34ac7cf4599d507",
"assets/assets/images/animals/ostrich.png": "ef842f8e9c6ebf53b7d5ebbf306c15c3",
"assets/assets/images/animals/owl.png": "cbf182b19da53174cbd1dd8eae0f85f3",
"assets/assets/images/animals/ox.png": "30eef626ed24d6a319bf409b922060a8",
"assets/assets/images/animals/panther.png": "731d5c7109e1c5fc9684901bcd23a6ab",
"assets/assets/images/animals/parrot.png": "dccadea590525f57f1ea844520ccf496",
"assets/assets/images/animals/penguin.png": "d062b14307388cadd62354ad225100ca",
"assets/assets/images/animals/rhinoceros.png": "6a5bcff7b66f68146601287d270a1db7",
"assets/assets/images/animals/shark.png": "69d78e7c115afce5b36c96d7fda9d11f",
"assets/assets/images/animals/sheep.png": "16d999fff3b9e939ba2cd3e8f320e6c9",
"assets/assets/images/animals/squirrel.png": "a0439fba27f5037fab85cba232246604",
"assets/assets/images/animals/tiger.png": "46ad4136dcb37797dae83d2e230e3f63",
"assets/assets/images/animals/turtle.png": "fea23ca9fd3a651619de4d38930014a6",
"assets/assets/images/animals/whale.png": "77f146ab9ec7615df79e318385d7b331",
"assets/assets/images/animals/wolf.png": "7f240e36599b8f93dcadc952c1071b11",
"assets/assets/images/animals/zebra.png": "63b36fdf477a039055e49828984846d5",
"assets/assets/images/banner/banner1.png": "9ab80b42f86529bf7d4e24dd8fbab77e",
"assets/assets/images/banner/banner2.png": "a07f42f036a549c279ee611eda9b9c94",
"assets/assets/images/banner/banner3.png": "1b426e1db15076d2b1cc02c7c0109817",
"assets/assets/images/banner/banner4.png": "112a55f7a109d78064cf8ce7835a5027",
"assets/assets/images/colors/Aqua.png": "1e4e9c37ef1a7d9753e8638b61828316",
"assets/assets/images/colors/Beige.png": "f882a243925305a98b266fec2d299aff",
"assets/assets/images/colors/Black.png": "51786a3f368c53d0a97c14f64c619304",
"assets/assets/images/colors/Blue.png": "a2e341a879d9e01f6020b11e7f127893",
"assets/assets/images/colors/Bronze.png": "b1494f3a97c38426e5e064365f689cc7",
"assets/assets/images/colors/Brown.png": "fe6f35d92d873ff17baf495a769a8687",
"assets/assets/images/colors/Burgundy.png": "439e9070d83611e309ed735bde75bb81",
"assets/assets/images/colors/Coral.png": "a8330fc9cfad8edb85070f108913cc5c",
"assets/assets/images/colors/Cream.png": "2cddf26ac75db1a93b3d6ce396f5d8dc",
"assets/assets/images/colors/Cyan.png": "9ad1ea2c716b90a32ef6f8172a9cb767",
"assets/assets/images/colors/Golden.png": "bea6f3ee474a1214fb3fd92660628a18",
"assets/assets/images/colors/Gray.png": "d28b47dc853e377c1f596f199cbf71d6",
"assets/assets/images/colors/Green.png": "d0045daa6e412bd251385d34c749fe4b",
"assets/assets/images/colors/Lavender.png": "58f66c86778f86a5ad89f9e190b9c3ef",
"assets/assets/images/colors/Lime.png": "85315802408f11d4cbdcd2708df6fc30",
"assets/assets/images/colors/Magenta.png": "c67d5c3125cfdc1ad6a2891a31611012",
"assets/assets/images/colors/Maroon.png": "01ce70928462bfd6f0879cd1f8ddf024",
"assets/assets/images/colors/Mustard.png": "9fc07e4b81b13e1027150caa01e47ce5",
"assets/assets/images/colors/NavyBlue.png": "ce0b22d67aac709ce575015912de0f12",
"assets/assets/images/colors/Olive.png": "6477de32786cedba02598b62ce7b00ca",
"assets/assets/images/colors/Orange.png": "417ca0724997e0a84cbba65b3776598b",
"assets/assets/images/colors/Peach.png": "cd4632a1444b3275d0e6977dd1eef8f6",
"assets/assets/images/colors/Pink.png": "9009cd1bd59e065a93fbee09e0cb3eed",
"assets/assets/images/colors/Purple.png": "43bed96e4e15f432ddc19119e22cc7b5",
"assets/assets/images/colors/Red.png": "f2720e5c76964c481081721195a50cb7",
"assets/assets/images/colors/Rust.png": "0dc6a409633a586aea67b6fd0ff1a0b9",
"assets/assets/images/colors/Silver.png": "ea64c88cf71c8f4a3d9476033f993359",
"assets/assets/images/colors/Teal.png": "293e76966caff37ac56b7f77c8d9976c",
"assets/assets/images/colors/White.png": "77bfe22e2a0055a727b58bfd83a64424",
"assets/assets/images/colors/Yellow.png": "1a627981f037e4c82dcc4febf1603d3b",
"assets/assets/images/feedings/ChubbyBoy.png": "a5b3a3a155640886115e0be124df5c6f",
"assets/assets/images/fruits/apple.png": "74d659a832d30e1c6820b637e1717ae6",
"assets/assets/images/fruits/apricot.png": "d9e316d44af450f22ff58c6ae3b8c103",
"assets/assets/images/fruits/avocado.png": "ae226f2395c0632190b2a19d9cafdbee",
"assets/assets/images/fruits/banana.png": "8fef5f7657fdb1674ae241f066db7b6f",
"assets/assets/images/fruits/blueberry.png": "c3e9a902e8898e7dbf007c9cdac8a5df",
"assets/assets/images/fruits/cactus_fruit.png": "6161e6664b7cb4ed251c8d1dadd549d8",
"assets/assets/images/fruits/cherry.png": "697ec810fe7f7ce81e15465dc400c00d",
"assets/assets/images/fruits/citron.png": "f38f4639f31013b457728a4e069fd778",
"assets/assets/images/fruits/coconut.png": "13f3cc4c2dc12270d82cb26087fea66b",
"assets/assets/images/fruits/date.png": "849a42b6e2321d052e97fe1fd0381b6f",
"assets/assets/images/fruits/fig.png": "1c905b02fa27b0a2a1055046be54326b",
"assets/assets/images/fruits/grape.png": "9782d032192cb73585ff5b6b4b97dbc5",
"assets/assets/images/fruits/guava.png": "84cea0a56be8cbc0c40feb709e5dc357",
"assets/assets/images/fruits/lemon.png": "52d674c27316c50d9c34d2f57d0d62ea",
"assets/assets/images/fruits/lychee.png": "2d9a9f7e2bfe8ff4a20843bf993620ac",
"assets/assets/images/fruits/mango.png": "cac3186a4ba38c212e7d8ce59919bf2e",
"assets/assets/images/fruits/nectarine.png": "b295633a57f77b53ef6cbe1039f6c2bf",
"assets/assets/images/fruits/orange.png": "fc4bdd9add9b6a286e84d8cfb086a12b",
"assets/assets/images/fruits/papaya.png": "f10796b69283b86ad6df60713ff08ef6",
"assets/assets/images/fruits/passion_fruit.png": "22888759f032a047728eeeb62013d27f",
"assets/assets/images/fruits/peach.png": "532a80e492ee68fad075f6f89f7f1d07",
"assets/assets/images/fruits/pear.png": "a32846ac336983622b5ced42680330a3",
"assets/assets/images/fruits/pineapple.png": "06dd11619827f324d92f832c3b38ae8e",
"assets/assets/images/fruits/plum.png": "f70516ebd988286849a3498d050d7a3a",
"assets/assets/images/fruits/pomegranate.png": "a12b13681bb0df8db818c96c6e59a023",
"assets/assets/images/fruits/soursop.png": "82a7b6e9f2eb4b75088578a211916428",
"assets/assets/images/fruits/strawberry.png": "06dcc166b6bca0bfab83e3374a5d93ff",
"assets/assets/images/fruits/tangerine.png": "55937a3ee86fa4bb20111f04da8b78ef",
"assets/assets/images/fruits/watermelon.png": "869d769e160f816e9f8db48a4ed4df1c",
"assets/assets/images/fruits/white_sapote.png": "d38219ff5874b48282b78fa8b796274f",
"assets/assets/images/logos/logo1.png": "b59f8e17527bb741c15c202cd2cb1b6a",
"assets/assets/images/spaces/astronaut.png": "85125ee3c19aec481eae023693077abd",
"assets/assets/images/spaces/chicken_astronaut.png": "2cfb1107b836c7c4df38e954881fbf7f",
"assets/assets/images/spaces/earth.png": "147d4a3d5d947bc35868bff059517064",
"assets/assets/images/spaces/jupiter.png": "6cba38f8890b43d8c040ca2edf11a80b",
"assets/assets/images/spaces/mars.png": "07d74cf53ac361f7b8eea350713a0ff4",
"assets/assets/images/spaces/mercury.png": "aacefa05a86a10d1dd0ff77c475bf358",
"assets/assets/images/spaces/space_map_full.png": "254226a6d8436289ee77b8a5e5a68827",
"assets/assets/images/spaces/space_single.png": "f504c95842808a6f376c61f2634be23f",
"assets/assets/images/spaces/sun.png": "3e1f017173ff342fee7ac429335cb50f",
"assets/assets/images/spaces/venus.png": "e1d487097f3831d466c08d72e97dcdd4",
"assets/assets/images/treasures/chick_character.png": "779e07ff7135b9406d1e9d5960224f5d",
"assets/assets/images/treasures/treasure_banner.png": "1f0f92d3e63e82f5c3232c72702a08a4",
"assets/assets/images/treasures/treasure_bg.png": "fdaeb5f054244306ac12b4a9fbaf7217",
"assets/assets/images/treasures/treasure_chest.png": "731b2bc370eb026920511a2d04f3e9c8",
"assets/assets/images/treasures/treasure_map.png": "155176e8e766275f42f66970d2d7d523",
"assets/assets/images/treasures/treasure_pirateking1.png": "0cca4ff8325ec80cb2af115bb1c3cc51",
"assets/assets/images/treasures/treasure_pirateking2.png": "7a663bc888c55459a65b547b31c7ae09",
"assets/assets/images/treasures/treasure_pirateking3.png": "9eac17badc558f15ed226159e24a24df",
"assets/assets/images/treasures/treasure_pirateking4.png": "8824ec812cdf67d711f51a007cba4cd0",
"assets/assets/images/treasures/treasure_pirateking5.png": "efd9b6a505ffcaf8b2af785106214608",
"assets/assets/sounds/success_bell.mp3": "4eb0e5d0ec6119778e1f4f1f03c87c35",
"assets/assets/sounds/success_bell2.mp3": "331ec1cc71e7700119e18ceba9429824",
"assets/assets/translations/en-US.json": "5a0b97c23dc82068d96c1a69c22a7a02",
"assets/assets/translations/ja-JP.json": "2b10c3eb784bb0b213d2c7f90b38364c",
"assets/assets/translations/vi.json": "929ea686946e2fe80df736e31ceaef87",
"assets/FontManifest.json": "7c2f9c9a3d24c7c114a2f72c02f0937b",
"assets/fonts/MaterialIcons-Regular.otf": "da6e1c04ddca2c67bb0fcf9bb497022e",
"assets/NOTICES": "236bb41948f2dab1971eaeb4076edc75",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "f7b2f1eb1a59e2b852582c82d2f1c080",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "40137b0823478af8cc6992d936ff7806",
"/": "40137b0823478af8cc6992d936ff7806",
"main.dart.js": "2aef72d882c5837159d34a46163c8d7d",
"manifest.json": "cb6a721f9328b0213222e4eaa61f37dd",
"version.json": "bb7cc239d94d836cb9d2577062622625"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
