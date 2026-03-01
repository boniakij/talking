import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export function AdminsPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Admin Management</h1>
        <p className="text-muted-foreground">
          Manage administrator accounts
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Administrators</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground">Admin list coming soon</p>
        </CardContent>
      </Card>
    </div>
  );
}
