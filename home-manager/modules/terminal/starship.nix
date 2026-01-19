{
  programs.starship = {
    enable = true;
    settings = {
      # Reduced from 10000ms - if a module takes >1s, it's slowing your prompt
      command_timeout = 1000;
      format = "$character$directory";
      right_format = "$all";

      # Disable slow/unused modules for faster prompt rendering
      ruby.detect_variables = [ ];
      aws.disabled = true;
      gcloud.disabled = true;
      # Disable package version checks (slow in large repos)
      package.disabled = true;

      cmd_duration = {
        min_time = 0;
        show_milliseconds = false;
      };

      # Git optimizations - only check in git dirs, skip slow operations
      git_status = {
        disabled = false;
        # These can be slow in large repos
        ignore_submodules = true;
      };
    };
  };
}
