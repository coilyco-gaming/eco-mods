// Copyright (c) Strange Loop Games. All rights reserved.
// See LICENSE file in the project root for full license information.

using UnityEngine;

public class DepthPrepass : BehaviourSingleton<DepthPrepass>
{
    public Material DepthPrePassOpaqueMaterial;
    public Material DepthPrePassTransparentMaterial;

    public Material[] FadeVariants;
}
