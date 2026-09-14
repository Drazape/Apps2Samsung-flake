{
	description = "One-click app installer for Samsung TVs, projectors and smart monitors (Tizen)";

	inputs = {
		flake-parts = { type="github"; owner="hercules-ci"; repo="flake-parts"; };
		nixpkgs = { type="github"; owner="NixOS"; repo="nixpkgs"; ref="nixpkgs-unstable"; };
		apps2samsung = {
			url = "https://github.com/Apps2Samsung/Apps2Samsung/releases/download/v2.7.9/Apps2Samsung-v2.7.9-linux-x64.deb";
			flake = false;
		};
	};

	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = ["x86_64-linux"];
			perSystem = { self', pkgs, lib, ... }: {
				packages = let pkgName = "apps2samsung"; in {
					${pkgName} = self'.packages.default;
					default  = pkgs.stdenvNoCC.mkDerivation {
						name = pkgName;
						src = inputs.${pkgName};
						
						nativeBuildInputs = with pkgs; [ dpkg autoPatchelfHook ];
						buildInputs = with pkgs; [ glibc gcc-unwrapped ];
						
						unpackPhase = ''
								dpkg --extract -- $src ./tree/
								cd ./tree/usr/
						'';
						
						installPhase = ''
								mkdir -p $out/
								mv ./bin/ ./share/ $out/
						'';

						meta = {
							description = "One-click app installer for Samsung TVs, projectors and smart monitors (Tizen)";
							homepage = "https://github.com/${pkgName}/"+pkgName;
							license = lib.licenses.gpl2;
							mainProgram = pkgName;
						};
					};
				};
			};
		};
}		 
