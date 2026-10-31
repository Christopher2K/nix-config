# Overlay adding sqlit. Takes { inputs } and returns the overlay lambda;
# coding.nix applies it as (import ./_sqlit-overlay.nix { inherit inputs; }).
# Underscore prefix keeps import-tree from auto-importing this as a module.
{ inputs }:
final: prev: {
  # snowflake-connector-python's tests fail on Python 3.14 (event-loop +
  # permission assertion issues); skip checks so sqlit can build.
  python3 = prev.python3.override {
    packageOverrides = pyFinal: pyPrev: {
      snowflake-connector-python = pyPrev.snowflake-connector-python.overridePythonAttrs (old: {
        doCheck = false;
        dontCheckRuntimeDeps = true;
      });
    };
  };

  # Rebuild sqlit from the upstream flake against our python3 so the
  # snowflake override applies (the flake's own packages close over
  # nixpkgs.legacyPackages and can't see our overlays).
  sqlit =
    let
      pyPkgs = final.python3.pkgs;
      version = "0.0.0+${inputs.sqlit.shortRev or "dirty"}";
    in
    pyPkgs.buildPythonApplication {
      pname = "sqlit";
      inherit version;
      pyproject = true;

      src = inputs.sqlit;

      build-system = [
        pyPkgs.hatchling
        pyPkgs."hatch-vcs"
        pyPkgs."setuptools-scm"
      ];

      nativeBuildInputs = [ pyPkgs.pythonRelaxDepsHook ];
      pythonRelaxDeps = [ "textual-fastdatatable" ];

      postPatch = ''
        export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
        export SETUPTOOLS_SCM_PRETEND_VERSION_FOR_SQLIT_TUI="${version}"
      '';

      dependencies = [
        pyPkgs.docker
        pyPkgs.keyring
        pyPkgs.pyperclip
        pyPkgs.sqlparse
        pyPkgs.textual
        pyPkgs."textual-fastdatatable"
        # extras (mirrors upstream nixpkgsExtras)
        pyPkgs.sshtunnel
        pyPkgs.paramiko
        pyPkgs.psycopg2
        pyPkgs.pymysql
        pyPkgs.duckdb
        pyPkgs.google-cloud-bigquery
        pyPkgs.snowflake-connector-python
        pyPkgs.requests
      ];

      pythonImportsCheck = [ "sqlit" ];

      meta = {
        description = "A terminal UI for SQL databases";
        homepage = "https://github.com/Maxteabag/sqlit";
        license = prev.lib.licenses.mit;
        mainProgram = "sqlit";
      };
    };
}
