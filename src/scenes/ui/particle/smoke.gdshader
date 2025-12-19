shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 color : source_color = vec4(0,0,0,1);
uniform int thickness = 3;

void fragment() {
    vec4 base = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 result;
    // Si pixel visible → normal
    if (base.a > 0.1) {
        result = base;
    }

    // Pixel transparent → on cherche autour
    bool outline = false;

    for (int x = -thickness; x <= thickness; x++) {
        for (int y = -thickness; y <= thickness; y++) {
            vec2 offset = vec2(float(x), float(y)) * SCREEN_PIXEL_SIZE;
            if (texture(SCREEN_TEXTURE, SCREEN_UV + offset).a > 0.1 && base.a == 0.0) {
                outline = true;
                break;
            }
        }
        if (outline) break;
    }

    COLOR = outline ? color : base;
	if (!outline) {
		COLOR = result;
	}
}
