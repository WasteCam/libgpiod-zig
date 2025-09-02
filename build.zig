// SPDX-License-Identifier: LGPL-2.1-or-later
// SPDX-FileCopyrightText: 2025 WasteCam Contributors

const std = @import("std");
const panic = std.debug.panic;
const builtin = @import("builtin");

// If we use a mutable global, we can only validate the target if we're actually building the library
// This means we can run --help without specifying a valid target
var is_valid_target: bool = false;

pub fn build(b: *std.Build) void {
    // Build options
    const options = b.addOptions();
    const linkage = b.option(std.builtin.LinkMode, "linkage", "Library linkage mode") orelse .static;
    options.addOption(std.builtin.LinkMode, "linkage", linkage);
    const target_raspberry_pi_4 = b.option(bool, "target_rpi_4", "Target the Raspberry Pi 4 model B") orelse false;
    options.addOption(bool, "target_raspberry_pi_4", target_raspberry_pi_4);

    // Target and optimize options
    const target = if (target_raspberry_pi_4) b.resolveTargetQuery(.{
        .cpu_arch = .arm,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_a72 },
        .os_tag = .linux,
        .abi = .gnueabihf, // GNU embedded ABI with hardware float support
    }) else b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    // Require Linux with GNU libc
    if (target.result.os.tag == .linux and target.result.abi.isGnu()) {
        is_valid_target = true;
    }
    const target_validate_step = b.allocator.create(std.Build.Step) catch panic("OOM", .{});
    target_validate_step.* = std.Build.Step.init(.{
        .id = .custom,
        .name = "validate-target",
        .makeFn = validateTarget,
        .owner = b,
    });
    b.getInstallStep().dependOn(target_validate_step);

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

fn validateTarget(step: *std.Build.Step, make_options: std.Build.Step.MakeOptions) !void {
    _ = step;
    _ = make_options;
    // Require Linux with GNU libc
    if (!is_valid_target) {
        panic("Target must be Linux with GNU libc\n", .{});
    }
}
