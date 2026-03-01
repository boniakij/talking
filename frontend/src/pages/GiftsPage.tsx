import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export function GiftsPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Gift Management</h1>
        <p className="text-muted-foreground">
          Manage virtual gifts and revenue
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Gifts</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground">Gift catalog coming soon</p>
        </CardContent>
      </Card>
    </div>
  );
}
