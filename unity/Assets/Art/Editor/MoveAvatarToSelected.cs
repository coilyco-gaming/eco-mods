#if UNITY_EDITOR

using UnityEditor;
using UnityEngine;

public class MoveAvatarToSelected : EditorWindow
{
    private GameObject selectedObject;
    private GameObject objectToMove;

    // Simple editor script to make it easier to repetetively check assets in a scene with the avatar
    [MenuItem("Tools/Move Avatar To Selected Object")]
    private static void ShowWindow()
    {
        GetWindow<MoveAvatarToSelected>("Move Avatar To Selected Object");
    }

    private void OnGUI()
    {
        GUILayout.Label("Used for repetetively testing the avatar next to a bunch of world objects\n\n" +
            "1. Drop the avatar into your scene\n" +
            "2. Drag the avatar into the field below\n" +
            "3. Click the button once you have a world object selected \n" +
            "4. Profit!", EditorStyles.boldLabel);

        EditorGUILayout.Space(10);

        objectToMove = EditorGUILayout.ObjectField("Avatar", objectToMove, typeof(GameObject), true) as GameObject;

        EditorGUILayout.Space(10);

        GUI.enabled = (objectToMove != null && selectedObject != null);
        if (GUILayout.Button("Come Here a Minute"))
        {
            MoveObjectToSelected();
        }
        GUI.enabled = true;
    }

    private void OnSelectionChange()
    {
        selectedObject = Selection.activeGameObject;
        Repaint();
    }

    private void MoveObjectToSelected()
    {
        if (objectToMove != null && selectedObject != null)
        {
            Vector3 newPosition = selectedObject.transform.position - new Vector3(0f, 0.5f, 0f);
            objectToMove.transform.position = newPosition;
            Debug.Log("Moved object to selected position.");

            Selection.activeGameObject = objectToMove;
        }
    }
}
#endif