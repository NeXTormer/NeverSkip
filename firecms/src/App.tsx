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

type ChartDataPoint = {
  metric: string,
  value: number,
  name: string,
  description: string,
}

type FredericUser = {
  name: String,
  email: String,
  image: String,
  has_purchased: Boolean,
  last_login: Date,
  last_os: String,
  last_os_version: String,
  is_developer: Boolean,
  should_reload_data: Boolean,
  trial_start: Date
}

const usersCollection = buildCollection<FredericUser>({
  path: "users",
  name: "Users",
  icon: "group",
  singularName: "User",
  properties: {
    name: {
      name: "Name",
      validation: { required: false },
      dataType: "string",
      readOnly: true,
    },
    email: {
      name: "EMail",
      dataType: "string",
      validation: { required: false },
      readOnly: true,
    },
    image: {
      name: "Image",
      dataType: "string",
      readOnly: true,
    },
    has_purchased: {
      name: "Has purchased",
      dataType: "boolean",
    },
    last_login: {
      name: "Last login",
      dataType: "date",
      readOnly: true
    }
    last_os
  }
});

const chartDataPointsCollection = buildCollection<ChartDataPoint>({
  path: "appdata",
  name: "Datenpunkte",
  icon: "Addchart",
  singularName: "Datenpunkt",
  properties: {
    name: {
      name: "Name",
      validation: { required: false },
      dataType: "string"
    },
    description: {
      name: "Beschreibung",
      dataType: "string",
      markdown: true,
      validation: { required: false },
      columnWidth: 1000
    },
    metric: {
      name: "Kennzahl",
      dataType: "string",
      validation: { required: true },
      enumValues: {
        exz: "Existenzzahl",
        pz: "Prägungszahl",
        fz: "Entfaltungszahl",
        sz: "Schwingungszahl",
        emz: "Empfindungszahl"
      }
    },
    value: {
      name: "Wert",
      dataType: "number",
      validation: {
        required: true,
        min: 1,
        max: 9
      },
    }
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

    console.log("Allowing access to", user?.email);
    // This is an example of retrieving async data related to the user
    // and storing it in the user extra field.
    const sampleUserRoles = await Promise.resolve(["admin"]);
    authController.setExtra(sampleUserRoles);

    return true;

  }, []);

  return <FirebaseCMSApp
    name={"Hexoskop"}
    authentication={myAuthenticator}
    collections={[chartDataPointsCollection]}
    firebaseConfig={firebaseConfig}
  />;
}
