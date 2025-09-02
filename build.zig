const std = @import("std");
const panic = std.debug.panic;

pub fn build(b: *std.Build) void {
    // Build options
    const linkage = b.option(
        std.builtin.LinkMode,
        "linkage",
        "Library linkage mode",
    ) orelse .static;
    const target_raspberry_pi_4 = b.option(
        bool,
        "target_raspberry_pi_4",
        "Target the Raspberry Pi 4 model B",
    ) orelse false;

    // Target and optimize options
    const target = if (target_raspberry_pi_4) b.resolveTargetQuery(.{
        .cpu_arch = .arm,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_a72 },
        .os_tag = .linux,
        .abi = .gnueabihf, // GNU embedded ABI with hardware float support
    }) else b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    // Target must be linux with glibc
    if (target.result.os.tag != .linux) {
        panic("Target OS must be Linux", .{});
    }
    if (!target.result.abi.isGnu()) {
        panic("Target ABI must be GNU libc", .{});
    }

    // Library options
    const lib = b.addLibrary(.{
        .name = "gpiod",
        .linkage = linkage,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    lib.root_module.addCMacro("GPIOD_VERSION_STR", "\"2.3-devel\"");
    lib.root_module.addCMacro("_GNU_SOURCE", ""); // Enable GNU glibc extensions
    lib.linkLibC();

    // Add source files
    lib.root_module.addCSourceFiles(.{
        .root = b.path("."),
        .files = &.{
            "lib/chip.c",
            "lib/chip-info.c",
            "lib/edge-event.c",
            "lib/info-event.c",
            "lib/internal.c",
            "lib/line-config.c",
            "lib/line-info.c",
            "lib/line-request.c",
            "lib/line-settings.c",
            "lib/misc.c",
            "lib/request-config.c",
        },
        .flags = &.{
            "-std=gnu89",
            "-Wall",
            "-Wextra",
        },
    });
    lib.root_module.addIncludePath(b.path("include/"));

    // Install step
    lib.installHeadersDirectory(b.path("include/"), "", .{});
    b.installArtifact(lib);
}
