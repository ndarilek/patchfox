<script>
  const { onMount, onDestroy } = require("svelte");
  const {
    connected,
    route,
    navigate,
    currentView,
    connect,
    reconnect,
    routeLocation,
    keepPinging,
    loadCaches,
  } = require("./utils.js");
  const { getPref } = require("./prefs.js");
  const Navigation = require("./Navigation.svelte");

  let useShortColumn = getPref("columnSize", "short") == "short";
  console.log("columnSize", useShortColumn);

  onMount(async () => {
    try {
      await connect();
      await loadCaches();

      keepPinging();
    } catch (n) {
      console.error("connect error", n);
      switch (n) {
        case "Can't connect to sbot":
          // need to be able to go to settings even though no connection is
          // established.
          if ($routeLocation !== "/settings") {
            window.location = "/docs/index.html#/troubleshooting/no-connection";
          }
          break;
        default:
          navigate("/error", { error: n });
          break;
      }
    }
  });

  const popState = event => {
    if (event.state !== null) {
      console.dir("pop", event.state);
      let { location, data } = event.state;
      route.set({ location, data });
    }
  };

  const handleUncaughtException = event => {
    console.error("Uncaught exception", event);
    navigate("/error", { error: event.message });
  };

  const hashChange = event => {
    console.dir("hash change", event);
  };
</script>

<style>
  .reduced-line-length {
    max-width: 840px;
    margin: auto;
  }
</style>

<svelte:window
  on:popstate={popState}
  on:error={handleUncaughtException}
  on:hashchange={hashChange} />

<div class="container bg-gray">
  <Navigation />
  <div class="columns">
    <div class="column" class:reduced-line-length={useShortColumn}>
      <svelte:component this={$currentView} />
    </div>
  </div>
</div>
