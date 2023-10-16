shader_type canvas_item;

uniform vec2 rect_size;
uniform vec2 grid_offset;
uniform float hex_width;

float pingpong(float f, float scale) {
	return scale - abs(mod(abs(f), 2.0*scale) - scale);
}

ivec2 coord_to_idx(vec2 c) {
	float y = c.y * 2.0 / sqrt(3.0);
	float x = c.x;
	
	if (pingpong(y, 1.0) > 0.5) {
		x -= 0.5;
	}
	
	int x_idx = int(round(x));
	int y_idx = int(round(y));
	
	return ivec2(x_idx, y_idx);
}

vec2 idx_to_coord(ivec2 i) {
	float y = float(i.y);
	float x = float(i.x);
	if (pingpong(y, 1.0) > 0.5) {
		x += 0.5;
	}
	return vec2(x, y*sqrt(3.0)/2.0);
}

struct PixelHexData {
	float center_dist;
	float edge_dist;
	ivec2 hex_idx;
	vec2 center_coord;
};

ivec2[6] adjacent_hexs(ivec2 idx) {
	ivec2 offsets[6] = {
		ivec2(-1, 1),	// top left
		ivec2(0, 1),	// top right
		ivec2(-1, 0),	// left
		ivec2(1, 0),	// right
		ivec2(-1, -1),	// bottom left
		ivec2(0, -1)	// bottom right
	};
	ivec2 outputs[6];
	for (int i = 0; i < 6; i++) {
		if (offsets[i].y == 0) {
			outputs[i] = idx + offsets[i];
		} else {
			if (pingpong(float(idx.y), 1.0) > 0.5) {
				outputs[i] = idx + offsets[i] + ivec2(1, 0);
			} else {
				outputs[i] = idx + offsets[i];
			}
		}
	}
	return outputs;
}

PixelHexData get_hex(vec2 coord) {
	ivec2 base_idx = coord_to_idx(coord);
	
	float best_dist = distance(idx_to_coord(base_idx), coord);
	vec2 hex_vec = idx_to_coord(base_idx);
	
	ivec2[6] adjacent = adjacent_hexs(base_idx);
	for (int i = 0; i < 6; i++) {
		vec2 hex_center = idx_to_coord(adjacent[i]);
		float d = distance(hex_center, coord);
		if (d < best_dist) {
			hex_vec = hex_center;
			best_dist = d;
		}
	}
	
	ivec2 hex_idx = coord_to_idx(hex_vec);
	
	adjacent = adjacent_hexs(hex_idx);
	
	vec2 offset_coords = coord - hex_vec;
	float snap_inc = PI/3.0;
	float theta = mod(atan(offset_coords.y, offset_coords.x) + 11.0*PI/6.0, 2.0*PI);
	int angle_idx = int(round((theta / snap_inc) - 0.5));
	float angles[6] = {
		150.0,
		210.0,
		270.0,
		330.0,
		390.0,
		450.0
	};
	
	int angle_to_adjacent[6] = {
		1,
		0,
		2,
		4,
		5,
		3
	};
	
	vec2 unit_vec = vec2(cos(angles[angle_idx] * PI/180.0), sin(angles[angle_idx] * PI/180.0));
	vec2 adjacent_hex = idx_to_coord(adjacent[angle_to_adjacent[angle_idx]]);
	vec2 edge_center_vec = ((adjacent_hex + hex_vec) / 2.0);
	float edge_dist = length((coord - edge_center_vec) - (dot(coord - edge_center_vec, unit_vec))*unit_vec);
	
	return PixelHexData(
		best_dist,
		edge_dist,
		hex_idx,
		hex_vec
	);
}

void fragment() {
	// COLOR = vec4(mod(FRAGCOORD.xy / 1.1, 1.0), 0.0, 1.0);
	vec2 center = rect_size / 2.0;
	float d = 0.0;
	vec2 grid_pixel_coord = ((UV - center) / hex_width) + grid_offset;
	grid_pixel_coord.y = -grid_pixel_coord.y * (1.15 * sqrt(3.0)) / 2.0;
	vec2 scaled_pixel_coord = grid_pixel_coord;
	PixelHexData hex_data = get_hex(scaled_pixel_coord);
	hex_data.edge_dist *= hex_width;
	hex_data.center_dist *= hex_width;
	
	float line_width = 2.0;
	float falloff = 1.0;
	vec4 hex_color = vec4(0.8, 0.8, 0.8, 1.0);
	if (hex_data.hex_idx == ivec2(0, 0)) {
		line_width = 7.0;
	}
	
	if (hex_data.edge_dist < line_width / 2.0) {
		d = 1.0;
	} else if (hex_data.edge_dist < (line_width / 2.0) + falloff) {
		d = (-1.0 / falloff) * (hex_data.edge_dist - falloff - (line_width / 2.0));
	} else {
		d = 0.0;
	}
	COLOR = (d * hex_color) + ((1.0 - d) * vec4(1.0, 1.0, 1.0, 1.0));
}
