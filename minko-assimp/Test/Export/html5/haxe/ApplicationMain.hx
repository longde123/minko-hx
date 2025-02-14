package;


import Main;

@:access(lime.app.Application)
@:access(lime.system.System)


@:dox(hide) class ApplicationMain {


	public static function main () {

		lime.system.System.__registerEntryPoint ("Test", create);

		#if (!html5 || munit)
		create (null);
		#end

	}


	public static function create (config:Dynamic):Void {

		ManifestResources.init (config);

		#if !munit
		var app = new Main ();
		app.meta.set ("build", "3");
		app.meta.set ("company", "Company Name");
		app.meta.set ("file", "Test");
		app.meta.set ("name", "Test");
		app.meta.set ("packageName", "com.sample.test");
		app.meta.set ("version", "1.0.0");

		#if !flash
		
		var attributes:lime.ui.WindowAttributes = {

			allowHighDPI: false,
			alwaysOnTop: false,
			borderless: false,
			// display: 0,
			element: null,
			frameRate: 60,
			#if !web fullscreen: false, #end
			height: 0,
			hidden: #if munit true #else false #end,
			maximized: false,
			minimized: false,
			parameters: {},
			resizable: true,
			title: "Test",
			width: 0,
			x: null,
			y: null,

		};

		attributes.context = {

			antialiasing: 0,
			background: 16777215,
			colorDepth: 32,
			depth: true,
			hardware: true,
			stencil: true,
			type: null,
			vsync: false

		};

		if (app.window == null) {

			if (config != null) {

				for (field in Reflect.fields (config)) {

					if (Reflect.hasField (attributes, field)) {

						Reflect.setField (attributes, field, Reflect.field (config, field));

					} else if (Reflect.hasField (attributes.context, field)) {

						Reflect.setField (attributes.context, field, Reflect.field (config, field));

					}

				}

			}

			#if sys
			lime.system.System.__parseArguments (attributes);
			#end

		}

		app.createWindow (attributes);
		
		#elseif !air

		app.window.context.attributes.background = 16777215;
		app.window.frameRate = 60;

		#end
		#end

		// preloader.create ();

		for (library in ManifestResources.preloadLibraries) {

			app.preloader.addLibrary (library);

		}

		for (name in ManifestResources.preloadLibraryNames) {

			app.preloader.addLibraryName (name);

		}

		app.preloader.load ();

		#if !munit
		start (app);
		#end

	}


	public static function start (app:lime.app.Application = null):Void {

		#if !munit

		var result = app.exec ();

		#if (sys && !ios && !nodejs && !emscripten)
		lime.system.System.exit (result);
		#end

		#else

		new Main ();

		#end

	}


	@:noCompletion @:dox(hide) public static function __init__ () {

		var init = lime.app.Application;

		#if neko
		// Copy from https://github.com/HaxeFoundation/haxe/blob/development/std/neko/_std/Sys.hx#L164
		// since Sys.programPath () isn't available in __init__
		var sys_program_path = {
			var m = neko.vm.Module.local().name;
			try {
				sys.FileSystem.fullPath(m);
			} catch (e:Dynamic) {
				// maybe the neko module name was supplied without .n extension...
				if (!StringTools.endsWith(m, ".n")) {
					try {
						sys.FileSystem.fullPath(m + ".n");
					} catch (e:Dynamic) {
						m;
					}
				} else {
					m;
				}
			}
		};

		var loader = new neko.vm.Loader (untyped $loader);
		loader.addPath (haxe.io.Path.directory (#if (haxe_ver >= 3.3) sys_program_path #else Sys.executablePath () #end));
		loader.addPath ("./");
		loader.addPath ("@executable_path/");
		#end

	}


}