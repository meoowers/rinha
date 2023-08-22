import Rinha
import Ash

open Ash.App
open Ash
open Rinha

open Rinha.Entities

def app (_db: Pgsql.Connection) : Ash.App Unit := do

  post "/pessoas" $ λ conn => do
    let person : Option Person := conn.json
    match person with
    | some person => conn.created person
    | none        => conn.unprocessableEntity "Invalid JSON"

  get "/pessoas/:id" $ λ conn => do
    let t := conn.bindings.find? "id"
    match t with
    | some query => conn.ok s!"hi {query}" 
    | none       => conn.badRequest "Bad Request"

  get "/pessoas" $ λ conn => do
    let t := conn.query.find? "t"
    match t with
    | some query => conn.ok s!"ok bro {query}" 
    | none       => conn.badRequest "Bad Request"
  
  get "/contagem-pessoas" $ λ conn => do
    conn.ok "Hello, world"

def main : IO Unit := do
  let conn ← Pgsql.connect "postgresql://postgres:1234@localhost:5432/teste"
  IO.println s!"Conneted to database"
  let port := "9999"
  (app conn).run "0.0.0.0" port do
    IO.println s!"Server running on port {port}"
