const rl = @import("raylib");

pub fn main() !void {
    // Initialize window
    const screenWidth = 800;
    const screenHeight = 450;
    rl.initWindow(screenWidth, screenHeight, "my title");
    defer rl.closeWindow();

    // Set target FPS
    rl.setTargetFPS(60);

    // Main game loop
    while (!rl.windowShouldClose()) {
        // Draw
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        rl.drawText("Congrats! You created your first window!", 190, 200, 20, rl.Color.light_gray);
    }
}
