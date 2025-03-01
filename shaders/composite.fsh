#version 460

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform float viewHeight;
uniform float viewWidth;

layout(location = 0) out vec4 outColor0;

in vec2 texCoord;
in vec3 foliageColor;
in vec2 lightMapCoords;


void main() {
    vec2 uv = gl_FragCoord.xy / vec2(viewWidth,viewHeight);

    // Получаем цвет текущего пикселя и соседних
    vec3 currentPixel = texture2D(gtexture, uv).rgb;
    vec3 rightPixel = texture2D(gtexture, uv + vec2(1.0 / viewWidth, 0.0)).rgb;
    vec3 bottomPixel = texture2D(gtexture, uv + vec2(0.0, 1.0 / viewHeight)).rgb;

    // Вычисляем разницу между текущим пикселем и соседними
    vec3 colorDifference = abs(currentPixel - rightPixel) + abs(currentPixel - bottomPixel);

    // Если разница велика, значит это граница, и можно нарисовать линию
    float edge = length(colorDifference) > 0.1 ? 1.0 : 0.0;

    outColor0 = vec4(vec3(edge), 1.0); // рисуем линию, если нашли границу
}