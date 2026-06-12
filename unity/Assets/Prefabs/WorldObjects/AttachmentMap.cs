// Copyright (c) Strange Loop Games. All rights reserved.
// See LICENSE file in the project root for full license information.

using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class AttachmentMap : TrackableBehavior
{
    public List<GameObject> prefabs;

    internal GameObject CreateAttachment(string name)
    {
        var prefab = prefabs.FirstOrDefault(x=>x.name == name);
        if (prefab) return GameObject.Instantiate(prefab);
        return null;
    }
}
