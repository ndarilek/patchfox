<script>
  const MessageRenderer = require("../messageTypes/MessageRenderer.svelte");
  const { navigate, routeParams } = require("../utils.js");
  const { getPref } = require("../prefs.js");
  const { onMount, onDestroy } = require("svelte");

  let msgs = false;
  let error = $routeParams.error || false;
  let channel = $routeParams.channel || false;
  let subscribed = false;
  let promise;

  if (!channel) {
    console.log("can't navigate to unnamed channel, going back to public");
    location = "index.html#/public"; // force reload.
  }

  let opts = {
    limit: $routeParams.limit || getPref("limit", 10),
    reverse: true
  };

  ssb.channelSubscribed(channel).then(s => (subscribed = s));

  // todo: move back into using stores.
  $: {
    Object.assign(opts, $routeParams);

    document.title = `Patchfox - #${channel}`;

    if (opts.hasOwnProperty("lt")) {
      opts.lt = parseInt(opts.lt);
    }

    if (opts.hasOwnProperty("limit")) {
      opts.limit = parseInt(opts.limit);
    }

    promise = ssb
      .channel(channel, opts)
      .then(ms => {
        console.log("msg", ms);
        msgs = ms;
        window.scrollTo(0, 0);
      })
      .catch(n => {
        if (!error) {
          console.error("errrrooooor", n);
        }
      });
  }

  const subscriptionChanged = ev => {
    let v = ev.target.checked;
    if (v) {
      ssb.channelSubscribe(channel).catch(() => (subscribed = false));
    } else {
      ssb.channelUnsubscribe(channel).catch(() => (subscribed = true));
    }
  };

  const goNext = () => {
    let lt = msgs[msgs.length - 1].value.timestamp;
    msgs = [];
    navigate("/channel", {
      channel,
      lt
    });
  };
  const goPrevious = () => {
    history.back();
  };
</script>

<style>
  .menu-right {
    right: 0px;
    left: unset;
    min-width: 300px;
  }
</style>

<div class="container">
  <div class="columns">
    <div class="column">
      <h4>Channel: #{channel}</h4>
    </div>
    <div class="column">
      <label class="form-switch float-right">
        <input
          type="checkbox"
          on:change={subscriptionChanged}
          bind:checked={subscribed} />
        <i class="form-icon" />
        Subscribe
      </label>
      <button
        class="btn btn-link float-right"
        href="?channel={channel}#/compose"
        on:click|preventDefault={() => navigate('/compose', { channel })}>
        New Post
      </button>
    </div>
  </div>
</div>
{#if error}
  <div class="toast toast-error">Error: {error}</div>
{/if}
{#await promise}
  <div class="loading loading-lg" />
{:then}
  {#each msgs as msg (msg.key)}
    <MessageRenderer {msg} />
  {:else}
    <p>No messages.</p>
  {/each}
  <ul class="pagination">
    <li class="page-item page-previous">
      <a href="#/public" on:click|stopPropagation|preventDefault={goPrevious}>
        <div class="page-item-subtitle">Previous</div>
      </a>
    </li>
    <li class="page-item page-next">
      <a href="#/public" on:click|stopPropagation|preventDefault={goNext}>
        <div class="page-item-subtitle">Next</div>
      </a>
    </li>
  </ul>
{/await}