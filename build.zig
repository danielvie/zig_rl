const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create the executable
    const exe = b.addExecutable(.{
        .name = "zig-raylib-example",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Create raylib module from raylib-zig
    const raylib_module = b.addModule("raylib", .{
        .root_source_file = b.path("lib/raylib-zig/lib/raylib.zig"),
    });

    // Add the raylib module to the executable
    exe.root_module.addImport("raylib", raylib_module);

    // Add C library linkage
    exe.linkLibC();

    // Link with pre-built raylib static library
    exe.addObjectFile(b.path("lib/raylib/lib/libraylib.a"));

    // Add include dir for raylib headers used by raylib-zig
    exe.addIncludePath(b.path("lib/raylib/include"));

    // Link with platform-specific libraries needed by raylib
    exe.linkSystemLibrary("winmm");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("opengl32");

    // Install the executable
    b.installArtifact(exe);

    // Create a run step
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
