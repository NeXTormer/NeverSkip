import React, { useCallback } from "react";

import { User as FirebaseUser } from "firebase/auth";
import {
  Authenticator,
  buildCollection,
  buildProperty,
  EntityReference,
  FirebaseCMSApp
} from "firecms";

import "typeface-rubik";
import "@fontsource/ibm-plex-mono";
import {firebaseConfig} from "./firebase-config";

import logo from "./assets/icon.png";


type FredericUser = {
  image: string,
  name: string,
  // email: string,
  has_purchased: boolean,
  last_login: Date,
  last_os: string,
  last_os_version: string,
  is_developer: boolean,
  should_reload_data: boolean,
  trial_start: Date
}

type FredericActivity = {
  image: string,
  name: string,
  description: string,
  recommendedreps: number,
  recommendedsets: number,
  type: string,
  musclegroup: Array<string>,
  owner: string,
}

const activitiesCollection = buildCollection<FredericActivity>({
  path: "activities",
  name: "Exercises",
  icon: "MenuBook",
  singularName: "Exercise",
  properties: {
    image: buildProperty({
      dataType: "string",
      name: "Image",
      url: "image",
      // storage: {
      //   storagePath: "icons",
      //   acceptedFiles: ["image/*"],
      //   maxSize: 256 * 256,
      //   metadata: {
      //     cacheControl: "max-age=1000000"
      //   },
      //   fileName: (context) => {
      //     return context.file.name;
      //   }
      // },
      readOnly: false,
    }),
    name: buildProperty({
      dataType: "string",
      name: "Name",
      validation: { required: true },
      readOnly: false,
    }),
    description: buildProperty({
      dataType: "string",
      name: "Description",
      validation: { required: false },
      readOnly: false,
      multiline: true,
    }),
    type: buildProperty({
      dataType: "string",
      name: "Type",
      validation: { required: true },
      readOnly: false,
      enumValues: {
        weighted: "Weighted",
        cali: "Calisthenics"
      }
    }),
    musclegroup: buildProperty({
      dataType: "array",
      name: "Muscle Groups",
      validation: { required: false },
      of: {
        dataType: "string",
        enumValues: {
          "arms": "Arms", "chest": "Chest", "back": "Back", "legs": "Legs", "core": "Core"
        }
      }
    }),
    recommendedreps: buildProperty({
      dataType: "number",
      name: "Reps",
      validation: { required: false },
      readOnly: false,
    }),
    recommendedsets: buildProperty({
      dataType: "number",
      name: "Sets",
      validation: { required: false },
      readOnly: false,
    }),
    owner: buildProperty({
      dataType: "string",
      name: "Owner",
      validation: { required: true },
      readOnly: false,
    }),
  }
});

const usersCollection = buildCollection<FredericUser>({
  path: "users",
  name: "Users",
  icon: "Person",
  singularName: "User",
  properties: {
    image: buildProperty({
      dataType: "string",
      name: "Image",
      url: "image",
      readOnly: true,

    }),
    name: buildProperty({
      dataType: "string",
      name: "Name",
      validation: { required: false },
      readOnly: true,
    }),
    // email: buildProperty({
    //   dataType: "string",
    //   name: "EMail",
    //   validation: { required: false },
    //   readOnly: true,
    // }),
    has_purchased: buildProperty({
      dataType: "boolean",
      name: "Has purchased",
    }),
    last_login: buildProperty({
      name: "Last login",
      dataType: "date",
      model: "date_time",
      readOnly: true
    }),
    should_reload_data: buildProperty({
      name: "Should reload data",
      dataType: "boolean"
    }),
    last_os: buildProperty({
      name: "Last OS",
      dataType: "string",
      readOnly: true,
    }),
    last_os_version: buildProperty({
      name: "Last OS verison",
      dataType: "string",
      readOnly: true,
    }),
    trial_start: buildProperty({
      name: "Trial start date",
      dataType: "date",
      model: "date_time",
      readOnly: true,
    }),
    is_developer: buildProperty({
      name: "Is developer",
      dataType: "boolean"
    }),

  }
});


export default function App() {

  const myAuthenticator: Authenticator<FirebaseUser> = useCallback(async ({
                                                                            user,
                                                                            authController
                                                                          }) => {

    if (user?.email?.includes("flanders")) {
      throw Error("Stupid Flanders!");
    }

    if(!user?.email?.startsWith("nextormer@gmail.com")) return false;

    console.log("Allowing access to", user?.email);

    return true;

  }, []);

  return <FirebaseCMSApp
    name={"NeverSkip Fitness"}
    authentication={myAuthenticator}
    collections={[usersCollection, activitiesCollection]}
    firebaseConfig={firebaseConfig}
    logo={logo}
  />;
}
