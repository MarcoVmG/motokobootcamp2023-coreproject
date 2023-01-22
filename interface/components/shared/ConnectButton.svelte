<script>
  import { plugConnection } from "../connexion"
  export let message = "Sign in"
</script>

<!-- <button on:click={() => plugConnection()}> {message} </button> -->

<button on:click={async () => await plugConnection()}> {message} </button>
