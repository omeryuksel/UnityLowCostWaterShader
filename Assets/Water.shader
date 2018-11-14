Shader "Unlit/Water"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_RefractTex("Texture", 2D) = "white" {}
		_Density("Density", Range(0,1)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _RefractTex;
			fixed _Density;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed shifter = tex2D(_RefractTex, i.uv + _Time.x).r;
				fixed shifter2 = tex2D(_RefractTex, i.uv + (_Time.x * 0.5f)).r;

				shifter *= _Density;
				shifter2 *= _Density * 0.2f;
				fixed4 col = tex2D(_MainTex, i.uv + shifter + shifter2);

				col.b *= 1+shifter * 5.0f;
				col.r *= 0.3f;

				return col;
			}
			ENDCG
		}
	}
}
