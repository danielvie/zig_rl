const std = @import("std");

pub fn build(b: *std.Build) void {
    // CONFIGURE TARGET AND OPTIMIZATION
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // CREATE THE EXECUTABLE
    const exe = b.addExecutable(.{
        .name = "zig-raylib-example",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // ADD RAYLIB DEPENDENCY
    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib"); // main raylib module
    const raygui = raylib_dep.module("raygui"); // raygui module
    const raylib_artifact = raylib_dep.artifact("raylib"); // raylib C library

    // Add the raylib module to the executable
    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addImport("raygui", raygui);

    // INSTALL THE EXECUTABLE
    b.installArtifact(exe);

    // CREATE A RUN STEP
    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "run application");
    run_step.dependOn(&run_exe.step);
}
