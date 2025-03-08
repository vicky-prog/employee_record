// @dart=3.6
// ignore_for_file: directives_ordering
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:drift_dev/integrations/build.dart' as _i2;
import 'package:source_gen/builder.dart' as _i3;
import '../../../tool/builder.dart' as _i4;
import 'package:build_web_compilers/builders.dart' as _i5;
import 'package:build_modules/builders.dart' as _i6;
import 'package:build_config/build_config.dart' as _i7;
import 'package:build/build.dart' as _i8;
import 'package:build_resolvers/builder.dart' as _i9;
import 'dart:isolate' as _i10;
import 'package:build_runner/build_runner.dart' as _i11;
import 'dart:io' as _i12;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(
    r'drift_dev:preparing_builder',
    [_i2.preparingBuilder],
    _i1.toNoneByDefault(),
    hideOutput: true,
    appliesBuilders: const [r'drift_dev:cleanup'],
  ),
  _i1.apply(
    r'drift_dev:drift_dev',
    [
      _i2.discover,
      _i2.analyzer,
      _i2.driftBuilder,
    ],
    _i1.toDependentsOf(r'drift_dev'),
    hideOutput: true,
    appliesBuilders: const [
      r'source_gen:combining_builder',
      r'drift_dev:preparing_builder',
    ],
  ),
  _i1.apply(
    r'source_gen:combining_builder',
    [_i3.combiningBuilder],
    _i1.toNoneByDefault(),
    hideOutput: false,
    appliesBuilders: const [r'source_gen:part_cleanup'],
  ),
  _i1.apply(
    r'employee_record:copy_compiled_worker_js',
    [_i4.CopyCompiledJs.new],
    _i1.toNoneByDefault(),
    hideOutput: false,
  ),
  _i1.apply(
    r'drift_dev:analyzer',
    [
      _i2.discover,
      _i2.analyzer,
    ],
    _i1.toNoneByDefault(),
    hideOutput: true,
    appliesBuilders: const [r'drift_dev:preparing_builder'],
  ),
  _i1.apply(
    r'drift_dev:not_shared',
    [_i2.driftBuilderNotShared],
    _i1.toNoneByDefault(),
    hideOutput: false,
  ),
  _i1.apply(
    r'drift_dev:modular',
    [_i2.modular],
    _i1.toNoneByDefault(),
    hideOutput: false,
    appliesBuilders: const [r'drift_dev:analyzer'],
  ),
  _i1.apply(
    r'build_web_compilers:sdk_js',
    [
      _i5.sdkJsCompile,
      _i5.sdkJsCopyRequirejs,
    ],
    _i1.toNoneByDefault(),
    isOptional: true,
    hideOutput: true,
  ),
  _i1.apply(
    r'build_modules:module_library',
    [_i6.moduleLibraryBuilder],
    _i1.toAllPackages(),
    isOptional: true,
    hideOutput: true,
    appliesBuilders: const [r'build_modules:module_cleanup'],
  ),
  _i1.apply(
    r'build_web_compilers:ddc_modules',
    [
      _i5.ddcMetaModuleBuilder,
      _i5.ddcMetaModuleCleanBuilder,
      _i5.ddcModuleBuilder,
    ],
    _i1.toNoneByDefault(),
    isOptional: true,
    hideOutput: true,
    appliesBuilders: const [r'build_modules:module_cleanup'],
  ),
  _i1.apply(
    r'build_web_compilers:ddc',
    [
      _i5.ddcKernelBuilder,
      _i5.ddcBuilder,
    ],
    _i1.toAllPackages(),
    isOptional: true,
    hideOutput: true,
    appliesBuilders: const [
      r'build_web_compilers:ddc_modules',
      r'build_web_compilers:dart2js_modules',
      r'build_web_compilers:dart2wasm_modules',
      r'build_web_compilers:dart_source_cleanup',
    ],
  ),
  _i1.apply(
    r'build_web_compilers:dart2wasm_modules',
    [
      _i5.dart2wasmMetaModuleBuilder,
      _i5.dart2wasmMetaModuleCleanBuilder,
      _i5.dart2wasmModuleBuilder,
    ],
    _i1.toNoneByDefault(),
    isOptional: true,
    hideOutput: true,
    appliesBuilders: const [r'build_modules:module_cleanup'],
  ),
  _i1.apply(
    r'build_web_compilers:dart2js_modules',
    [
      _i5.dart2jsMetaModuleBuilder,
      _i5.dart2jsMetaModuleCleanBuilder,
      _i5.dart2jsModuleBuilder,
    ],
    _i1.toNoneByDefault(),
    isOptional: true,
    hideOutput: true,
    appliesBuilders: const [r'build_modules:module_cleanup'],
  ),
  _i1.apply(
    r'build_web_compilers:entrypoint',
    [_i5.webEntrypointBuilder],
    _i1.toRoot(),
    hideOutput: true,
    defaultGenerateFor: const _i7.InputSet(
      include: [
        r'web/**',
        r'test/**.dart.browser_test.dart',
        r'example/**',
        r'benchmark/**',
      ],
      exclude: [
        r'test/**.node_test.dart',
        r'test/**.vm_test.dart',
      ],
    ),
    defaultOptions: const _i8.BuilderOptions(<String, dynamic>{
      r'dart2js_args': <dynamic>[r'--minify']
    }),
    defaultDevOptions: const _i8.BuilderOptions(<String, dynamic>{
      r'dart2wasm_args': <dynamic>[r'--enable-asserts'],
      r'dart2js_args': <dynamic>[r'--enable-asserts'],
    }),
    defaultReleaseOptions:
        const _i8.BuilderOptions(<String, dynamic>{r'compiler': r'dart2js'}),
    appliesBuilders: const [r'build_web_compilers:dart2js_archive_extractor'],
  ),
  _i1.apply(
    r'build_resolvers:transitive_digests',
    [_i9.transitiveDigestsBuilder],
    _i1.toAllPackages(),
    isOptional: true,
    hideOutput: true,
    appliesBuilders: const [r'build_resolvers:transitive_digest_cleanup'],
  ),
  _i1.applyPostProcess(
    r'build_resolvers:transitive_digest_cleanup',
    _i9.transitiveDigestCleanup,
  ),
  _i1.applyPostProcess(
    r'build_modules:module_cleanup',
    _i6.moduleCleanup,
  ),
  _i1.applyPostProcess(
    r'build_web_compilers:dart2js_archive_extractor',
    _i5.dart2jsArchiveExtractor,
    defaultReleaseOptions:
        const _i8.BuilderOptions(<String, dynamic>{r'filter_outputs': true}),
  ),
  _i1.applyPostProcess(
    r'build_web_compilers:dart_source_cleanup',
    _i5.dartSourceCleanup,
    defaultReleaseOptions:
        const _i8.BuilderOptions(<String, dynamic>{r'enabled': true}),
  ),
  _i1.applyPostProcess(
    r'source_gen:part_cleanup',
    _i3.partCleanup,
  ),
  _i1.applyPostProcess(
    r'drift_dev:cleanup',
    _i2.driftCleanup,
  ),
];
void main(
  List<String> args, [
  _i10.SendPort? sendPort,
]) async {
  var result = await _i11.run(
    args,
    _builders,
  );
  sendPort?.send(result);
  _i12.exitCode = result;
}
