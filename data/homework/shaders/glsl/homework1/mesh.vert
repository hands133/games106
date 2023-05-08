#version 450

layout (location = 0) in vec3 inPos;
layout (location = 1) in vec3 inNormal;
layout (location = 2) in vec2 inUV;
layout (location = 3) in vec3 inColor;
layout (location = 4) in uint inNodeIndex_hw1;

layout (set = 0, binding = 0) uniform UBOScene
{
	mat4 projection;
	mat4 view;
	vec4 lightPos;
	vec4 viewPos;
} uboScene;

layout(push_constant) uniform PushConsts {
	mat4 model;
} primitive;

layout(set = 2, binding = 0) readonly buffer skMatrices {
	mat4 skMatrices_hw1[];
};

layout (location = 0) out vec3 outNormal;
layout (location = 1) out vec3 outColor;
layout (location = 2) out vec2 outUV;
layout (location = 3) out vec3 outViewVec;
layout (location = 4) out vec3 outLightVec;

void main() 
{
	mat4 skMatrix_hw1 = skMatrices_hw1[inNodeIndex_hw1];

	outNormal = mat3(skMatrix_hw1) * inNormal;
	outColor = inColor;
	outUV = inUV;

	vec4 worldPos_hw1 = skMatrix_hw1 * vec4(inPos.xyz, 1.0);

	gl_Position = uboScene.projection * uboScene.view * worldPos_hw1;
	vec3 pos = worldPos_hw1.xyz / worldPos_hw1.w;

	outViewVec = uboScene.viewPos.xyz - pos.xyz;	
	outLightVec = uboScene.lightPos.xyz - pos.xyz;
}